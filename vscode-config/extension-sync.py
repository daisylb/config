#!/usr/bin/env python3

from subprocess import check_call, check_output


def prompt(question, answers):
    inp = None
    while True:
        inp = input("{} [{}]>".format(question, '/'.join(answers)))
        if inp in answers:
            break
        print("Enter one of {}".format(', '.join(answers)))
    return inp


if __name__ == "__main__":
    installed_packages_raw = check_output(('code', '--list-extensions')).decode('utf8')
    installed_packages = {x for x in installed_packages_raw.split('\n') if x}

    with open('extensions.txt') as pkgf:
        list_packages = {x for x in pkgf.read().split('\n') if x}

    missing_packages = list_packages.difference(installed_packages)
    rogue_packages = installed_packages.difference(list_packages)
    uninstall_candidates = set()

    for pkg in rogue_packages:
        action = prompt("{}: Add to list or Uninstall?".format(pkg), ['a', 'u'])
        if action == 'a':
            list_packages.add(pkg)
        if action == 'u':
            uninstall_candidates.add(pkg)

    for pkg in missing_packages:
        print("Installing {}".format(pkg))
        check_call(('code', '--install-extension', pkg))

    for pkg in uninstall_candidates:
        print("Uninstalling {}".format(pkg))
        check_call(('code', '--uninstall-extension', pkg))

    package_list = list(list_packages)
    package_list.sort()
    with open('extensions.txt', 'w') as pkgf:
        for pkg in package_list:
            pkgf.write(pkg)
            pkgf.write('\n')
