from jinja2.filters import environmentfilter, do_groupby


@environmentfilter
def do_dictby(environment, value, attribute):
    """convert groups as built by groupby filter into a dictionary"""
    groups = do_groupby(environment, value, attribute)
    return dict(groups)


class FilterModule(object):
    ''' Ansible core jinja2 filters '''

    def filters(self):
        return {
            'dictby': do_dictby,
        }
