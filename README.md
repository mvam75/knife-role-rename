knife-role-replace
=================
Rename a Chef role applied to a node

Install
=======

Copy replace.rb into ~/.chef/plugins/knife

Gem Install
===========

```
gem install knife-role-replace
```

How to use
==========

```
knife role replace -s search_role -o old_role_name -n new_role_name
```

Use the search role name to pick nodes that fit your criteria and replace any role on those hosts.

For example, if you had 20 hosts with the role 'base' and the role 'fake-service' applied and you wanted to change the role 'base'
to say 'linux-base' you would run --

```
knife role replace -s fake-service -o base -n linux-base
```

Thats it! The change gets saved to the node and you're ready to go.
