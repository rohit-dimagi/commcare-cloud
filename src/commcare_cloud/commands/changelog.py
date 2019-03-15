# from commcare_cloud.manage_commcare_cloud.make_changelog import compile_changelog
from commcare_cloud.manage_commcare_cloud.make_changelog import compile_changelog
from .command_base import CommandBase, Argument


class Changelog(CommandBase):
    command = 'changelog'
    help = (
        "Apply the changes from a specific changelog entry"
    )

    arguments = (
        Argument(dest='action', choices=['list', 'apply']),
        Argument('-l', dest='log', default=None),
    )

    def run(self, args, unknown_args):
        action = getattr(self, 'do_{}'.format(args.action))
        action(args, unknown_args)

    def do_list(self, args, unknown_args):
        changes = compile_changelog()
        for change in changes:
            print(change.filename)

    def do_apply(self, args, unknown_args):
        # apply the change
        # record the result (maybe a webhook or google form?
        pass
