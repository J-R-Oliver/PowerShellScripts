# EdgeOS CLI Guide

## Configuration and Operational Mode Basics

The default mode when logging into the command line is Operational Mode. To switch to Configuration Mode, use the configure command:

>`ubnt@edgerouter:~$ configure`
>                                                         
>`[edit]`                                                                      
>`ubnt@edgerouter#`

Operational Mode is indicated by a dollar sign $, whereas Configuration Mode uses the hashtag #. To go back to operational mode, use the exit command:

>`[edit]`                                                                          
>`ubnt@edgerouter# exit`
>`exit`
>
>`ubnt@edgerouter:~$`

You can use the question mark `?` key to display all the available commands in both modes. Press the `?` key twice to also display the command descriptions

If you wish to run an Operational Mode command from while in Configuration Mode, use the run command.

>`[edit]`
>`ubnt@edgerouter# run show ?`
>
>`Possible completions:`\
>  `interfaces......Show network interface information`\
>  `ip..............Show IPv4 routing information`\
>  `ipv6............Show IPv6 routing information`\
> `<...output shortened...>`

## Configuration Changes

The EdgeRouter uses three configuration sets:

- `Boot/Startup` Config When the EdgeRouter reboots, it loads the boot/startup configuration (config.boot)
- `Active Config` Currently active configuration with changes that have not been saved to the boot/startup configuration yet.
- `Working Config` Non-active configuration with changes that have not been applied (committed) yet.

Use the following commands to make changes to the configuration:

- `set` Adds a configuration statement from the device
- `delete` Removes a configuration statement from the device
- `commit` Applies any changes that were added with the set or delete commands
- `save` Saves the active configuration to the boot/startup configuration

The `compare` command will show you the difference between the **working** and the **active** configurations.

Save the configuration changes to the boot/startup configuration by using the save command:

>`[edit]`
>`ubnt@edgerouter# save`
>`Saving configuration to '/config/config.boot'...`

Instead of applying changes with the `commit` command, you can also use `commit-confirm`. The latter command reboots the device in 10 minutes (you can customize this value) unless the commit is *confirmed* with the `confirm` command. This is helpful when you are making changes to a remote device and you do not want to risk losing access to it. If you accidentally lock yourself out of the device, the EdgeRouter will reboot after 10 minutes and the **boot/startup** configuration is re-loaded.

## Useful Notes

- `show configuration` commands will show all the commands to reconfigure the router to exactly how it currently is.
- `;` allows you to chain commands together. Example: `commit;save;exit` will execute those 3 in order.
- `TAB` will autofill the rest of whatever commands are available. Example, if I type `set inteTAB` it'll autofill to `set interfaces`.
- `&&` will run commands in order only if the previous command completes. Example: `commit && save && exit` will execute `save` is `commit` completes, and `exit` only if `commit` completes. 
