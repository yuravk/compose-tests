#!/usr/bin/env python3
"""Split compose-tests into shards of roughly equal run time.

The tests run one at a time, so the CI runs them on several guests at once,
each guest getting one shard. Shards are filled longest-test-first using the
test durations of the CI variant (ci/test-durations/<variant>.txt, e.g. 9,
10-x86_64_v2 or 9-aarch64); a test missing there counts as its longest
duration in the other variants, or as --default seconds if none knows it.
Tests given with --always (0_common, which prepares the guest) go to every
shard, first.

Split the enabled tests into 4 shards, one tmt 'test --name' regex per line:

    tmt -c distro=centos-stream-9 tests ls --enabled | ci/shard.py split --shards 4 --variant 9

Refresh the durations from the '<variant> tests results' artifacts of CI runs,
as 'gh run download' saves them (the longest duration of each test wins;
needs PyYAML):

    ci/shard.py durations */*.results.yaml
"""

import argparse
import glob
import os
import re
import sys

VARIANT_DURATIONS = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 'test-durations')
ARTIFACT_SUFFIX = ' tests results'


def read_durations(path):
    durations = {}
    with open(path) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                seconds, name = line.split()
                durations[name] = int(seconds)
    return durations


def split(args):
    tests = [line.strip() for line in sys.stdin if line.strip()]
    if not tests:
        sys.exit('No tests given on stdin')
    durations = {}
    for path in sorted(glob.glob(os.path.join(args.durations_dir, '*.txt'))):
        for name, seconds in read_durations(path).items():
            durations[name] = max(durations.get(name, 0), seconds)
    if args.variant:
        path = os.path.join(args.durations_dir, f'{args.variant}.txt')
        if os.path.exists(path):
            durations.update(read_durations(path))
        else:
            print(f'[Debug] no {path}, using the longest of all the variants',
                  file=sys.stderr)

    def duration(test):
        return durations.get(test, args.default)

    always = [t for t in args.always if t in tests]
    shards = [[] for _ in range(args.shards)]
    load = [sum(duration(t) for t in always)] * args.shards
    for test in sorted(set(tests) - set(always), key=lambda t: (-duration(t), t)):
        i = load.index(min(load))
        shards[i].append(test)
        load[i] += duration(test)

    for i, shard in enumerate(shards):
        names = always + sorted(shard)
        print(f'[Debug] shard {i}: {len(names)} tests, ~{load[i] // 60} min',
              file=sys.stderr)
        print('^(' + '|'.join(re.escape(t) for t in names) + ')$')


def write_durations(path, longest, variant):
    with open(path, 'w') as f:
        f.write(f'# Longest duration in seconds of each test in recent CI runs of\n'
                f'# the {variant} variant, used by ci/shard.py to balance shards.\n'
                f'# Regenerate with: ci/shard.py durations */*.results.yaml\n')
        for name in sorted(longest):
            f.write(f'{longest[name]} {name}\n')
    print(f'[Debug] wrote {path}: {len(longest)} tests', file=sys.stderr)


def durations(args):
    import yaml

    by_variant = {}
    for path in args.results:
        artifact = os.path.basename(os.path.dirname(os.path.abspath(path)))
        if not artifact.endswith(ARTIFACT_SUFFIX):
            print(f"[Debug] skipping {path}: not in a '<variant>{ARTIFACT_SUFFIX}' directory",
                  file=sys.stderr)
            continue
        variant_longest = by_variant.setdefault(artifact[:-len(ARTIFACT_SUFFIX)], {})
        with open(path) as f:
            for result in yaml.safe_load(f) or []:
                if result.get('duration'):
                    h, m, s = (int(x) for x in result['duration'].split(':'))
                    seconds = h * 3600 + m * 60 + s
                    variant_longest[result['name']] = max(
                        variant_longest.get(result['name'], 0), seconds)
    os.makedirs(args.durations_dir, exist_ok=True)
    for variant, variant_longest in sorted(by_variant.items()):
        write_durations(os.path.join(args.durations_dir, f'{variant}.txt'),
                        variant_longest, variant)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    commands = parser.add_subparsers(dest='command', required=True)

    p = commands.add_parser('split', help='split tests read from stdin into shards')
    p.add_argument('--shards', type=int, required=True)
    p.add_argument('--variant', help='CI variant, e.g. 9, 10-x86_64_v2 or 9-aarch64')
    p.add_argument('--durations-dir', default=VARIANT_DURATIONS)
    p.add_argument('--default', type=int, default=15,
                   help='duration of a test no variant knows (seconds)')
    p.add_argument('--always', action='append', default=['/tests/legacy/0_common'],
                   help='test to run on every shard')
    p.set_defaults(func=split)

    p = commands.add_parser('durations', help='write the durations from results.yaml files')
    p.add_argument('results', nargs='+',
                   help="tmt results.yaml files in '<variant> tests results' directories")
    p.add_argument('--durations-dir', default=VARIANT_DURATIONS)
    p.set_defaults(func=durations)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
