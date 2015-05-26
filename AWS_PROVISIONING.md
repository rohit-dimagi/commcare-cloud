
 if you receive an error in provisioning an RDS instance:

    create_db_instance() got an unexpected keyword argument 'vpc_security_groups'

you will need to update ansible to version >= 1.9.1, where an update matches
this parameter name to the parameter required by boto 2:
"vpc_security_group_ids" (see https://github.com/ansible/ansible-modules-core/issues/954)


RDS instance will not be grouped by tags in the dynamic ec2 inventory (this
information is not returned by the boto api, nor by the core AWS api, so it's
not clear how one might ever get at it).  Therefore, some other means of
identifying the appropriate RDS instance will be required.  Instance name seems
the best option for now.
