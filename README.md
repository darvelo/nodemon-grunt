# What is it

This is a script that will allow you to run your `grunt server` command through nodemon, enabling you to modify your node.js server files and have your backend server instantly restarted to reflect the changes. With the files in this repository, you will be able to do this either through your standard *nix bash terminal, or through keyboard shortcuts in Sublime Text 2. If you're running your grunt server with Express, you'll find this especially helpful. node-inspector is also started so that you can debug your server code from within WebKit Inspector, just like you do on the frontend. :)


# Getting Started

You need Bash version 4 or higher for this to work. Check with `bash --version` in your terminal.
Grunt > 0.4 is **highly** recommended.

Make sure you have nodemon, grunt-cli, grunt, and node-inspector installed with npm:

`npm install -g nodemon grunt-cli node-inspector`

From within your project directory: `npm install grunt`

Place `nodemon-grunt.sh` into your project's root directory along with your `Gruntfile.js` file.

**Warning:** This script works by finding process ids that correspond to the keywords `grunt` and `node-inspector`. If you have other processes running with these names, they will be terminated by this script!

# Shell commands

These commands can be used in a standard `bash` terminal to run the script in different ways. `./` denotes the current directory, a prefix to the command that allows you to run the script when you `cd` to the project root.

* `./nodemon-grunt.sh` or `./nodemon-grunt start` - Start the nodemon grunt process in the terminal where it can be monitored.
* `./nodemon-grunt.sh restart` - Restart the nodemon grunt process, whether it was started in a Terminal or through Sublime. Any input typed into the terminal window (and then pressing enter) will also restart the process. The specific input combination can be changed by editing the `$input` check in `nodemon-grunt.sh`.
* `./nodemon-grunt.sh kill` - Kill the nodemon grunt process from another terminal.

`Ctrl+c` can be used to kill the process from the same terminal window/tab.


# Running with Sublime Text 2

Sublime Text 2 will be able to start, restart, or kill your nodemon grunt process from its own console window. No Terminal required.

To do so, make sure you have a .sublime-project file dedicated for this purpose. Using Sublime with Projects makes it possible to run, restart, or stop the grunt process while editing any of the files belonging to that project. Use the `Project` menu in Sublime and select `Save Project As...` to create a project.

Put `*.sublime-keymap` and `nodemon-grunt.sublime-build` into your Packages/User directory for Sublime. You can find it by going to `Preferences->Browse Packages...` in Sublime.

You'll have to go to `Tools->Build System` in Sublime and select `nodemon-grunt` for it to run automatically by keyboard shortcut.

Change the `path` in the .sublime-build file to reflect wherever your node path is. If you're using nvm, you can leave it as is and modify the line at the bottom of your ~/.nvm/nvm.sh file to read:

```bash
nvm ls default &>/dev/null && nvm use default >/dev/null && rm ~/.nvm_bin_alias &>/dev/null && ln -s $NVM_BIN ~/.nvm_bin_alias &>/dev/null || true
```

This will instruct nvm to create a file named `.nvm_bin_alias` in your $HOME directory that symlinks to the bin/ of whatever node version you happen to be using. The .sublime-build file will pick up on this symlink and add it to its path.

## Keyboard Bindings

The shell commands can also be invoked through Sublime keyboard shortcuts.

Merge the key-value pairs in the relevant `.sublime-keymap` files into the files of the same name in your Packages/User directory. If the file doesn't exist, you can simply copy the `.sublime-keymap` file into the Packages/User directory for Sublime to pick up the keybindings.

These handy keyboard shortcuts are available to start, stop, and restart your nodemon process from within Sublime. The defaults are meant not to conflict with Sublime's default keybindings, and can be modified as you wish by altering your User settings. These can be found by going to `Preferences->Key Bindings - User` in Sublime.

* `Super+Alt+B` - Start the nodemon process in the Sublime console where it can be monitored. An alias for this keybinding is of course the Sublime `build` keyboard shortcut, which defaults to `Ctrl+B`. Please keep in mind that pressing Esc will close the Sublime console, but not kill the nodemon grunt process.
* `Super+Alt+R` - Restart the nodemon grunt process, whether it was started in a Terminal or through Sublime.
* `Super+Alt+C` - Kill the nodemon grunt process.
