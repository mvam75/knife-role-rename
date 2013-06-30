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

Role Replace:

Use the search role name to pick nodes that fit your criteria and replace any role on those hosts.
```
knife role replace -s search_role -o old_role_name -n new_role_name
```

For example, if you had 20 hosts with the role 'base' and the role 'fake-service' applied and you wanted to change the role 'base'
to say 'linux-base' you would run --

```
knife role replace -s fake-service -o base -n linux-base
```

Role Add:

Use the search role name to pick nodes that fit your criteria, pick a role you want to add and pick its position on the run list.
```
knife role add -s search_role -n new_role -p position
```
For example, you want to insert the role 'foo' on nodes that already have bar --

```
knife role add -s bar -n foo -p 0
```

Thats it! The change gets saved to the node and you're ready to go.
