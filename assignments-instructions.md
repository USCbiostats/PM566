# Assignment workflow

For each assignment, the course instructors will distribute the materials in a
single compressed file (usually zip). Once the assignment materials are
available, the students are required to do the following:

1. Download the compress file and extract its contents into an empty folder.

2. Initialize the folder as a git repository, add its contents, and make
   the first commit.

3. Create a new repository in Github.com (under your account), and push
   your local repo into it. The name of the repository should be
   [name of the compressed file]-[your github username]

You can start working on your assignment! We recommend pushing your changes
as much as you can (it is a good practice). As soon as you finish your 
assignment, you will have to ping one of the instructors in your commit
message, for example:

```sh
git commit -a -m "Assignment done @gvegayon"
```

This way @gvegayon will receive a notification about this assignment. Furthermore,
we encourage you to use other github resources such as adding the URL of
[Github issue]() regarding that assignment, for example, if you include the
following link in your commit message:

```
git commit -a -m "Assignment done https://github.com/USCbiostats/PM566/issues/17"
```

The issue #17 in the PM566 website will now include a link to your commit. A
similar thing can be done by cross-referencing an issue, this is, if you create
a new issue in your repository and include the same link (https://github.com/USCbiostats/PM566/issues/17),
the issue will be shown in #17 as cross reference.

## Example

For week 3 we will distribute a zip file named `week3-assignment.zip`. Using
command line, you can do all the previous steps as follows:

```sh
cd ~
wget github.com/USCbiostats/PM566/raw/master/assignments/week3-assignment.zip
unzip week3-assignment.zip -d week3-assignment-gvegayon
cd week3-assignment-gvegayon
git init
git add .
git commit -a -m "Initial commit"
```

You still need to go to Github.com to create the new repository. Assuming
you do that successfully, we continue:

```sh
git remote add origin git@github.com:gvegayon/week3-assignment-gvegayon.git
git push -u origin master
```

And your are done!


