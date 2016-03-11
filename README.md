# "The" Vagrant

Install a vagrant environment into a project.

Run from within your project:

```
vendor/bin/phing -f vendor/palantirnet/the-vagrant/tasks/vagrant.xml
```

You may set the two properties from the command line to avoid the interactive prompt:

```
vendor/bin/phing -f vendor/palantirnet/the-vagrant/tasks/vagrant.xml -Dprojectname=PROJECTNAME -Dcopy=n
```
