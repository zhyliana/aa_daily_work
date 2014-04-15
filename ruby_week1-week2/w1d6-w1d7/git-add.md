# Using Git add

<b>TL;DR: Use `git add -A` instead of `git add .` or `git add -u`.</b>

## The background.

So you've been working on a small project, and you've been committing all your files at once every time... At some point, you realize that there's a file that you don't need anymore, so you delete it and write some more code.  

Eventually you run `git add .`, commit it, push it to github, and forget about it for a couple of weeks.

Two weeks later, you pull your repo from github.  You try testing out the code, but everything fails!  There are old classes and methods from the file you deleted that are cluttering up your code, climbin' in your windows, and snatchin' your methods up!

What happened?

When you run `git add .`  you're telling git, "take everything that's new or has changed in my current directory and add it to the staging area".  This does NOT remove the files that you deleted from the repo--it only adds files.  As a result, those files reappear when you pull down the repo again.

What should I do instead?

1. Ideally, you should be adding individual files as you create them, and running `git add -u filename` to update/delete them.  Do NOT just run `git add -u` because you won't be adding any new files; you're only updating files that git is already tracking.
2. If you really want to add all your files, use <b>`git add -A`</b>.  This is like a combination of `git add -u` and `git add .`; it will update/delete tracked files AND add new ones.

NOTE: -A and -u are options of the `git add` command.  They use the project
directory if you don't explicitly give them a filepath, e.g. `git add -u lib/board`.  

For example, `.` is the filepath that you pass in as an argument to `git add`.

## The visuals

<table>
	<tr>
		<td><strong>Command</strong></td><td><strong>Git add .</strong> (current directory)</td><td><strong>Git add -u</strong> (update)</td><td><strong>WINNER: Git add -A </strong>(all)</td>
	</tr>
	<tr>
		<td>Effect</td><td>Adds everything that is new/has changed in the current directory.</td><td>Updates already tracked files and removes them from staging area if they're not in the working directory.</td><td>Finds new files as well as updating old files. (git add . + git add -u)</td>
	</tr>
	<tr>
		<td>Downside</td><td>Doesn't get rid of files you want to delete!</td><td>Doesn't track new files!</td><td>If you find a downside, let us know.</td>
	</tr>
</table>

