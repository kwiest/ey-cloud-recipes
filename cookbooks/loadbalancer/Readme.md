# Util Load Balancer

## WARNING

First a few words of warning, using this setup comes with some drawbacks

* If your util slice freezes, you will need to provision a new one, and 
  have EY support move the ip attached to this instance.
* You will lose the ability to have automated failovers.
* If you add or remove app instances from your environment, you will
  need to run chef on the environment for these instances to appear in
  your load balancer.
* This setup assumes that you want to run stunnel on your environment
  and perform SSL termination on this utility slice. If you wish not to
  do this, you will have to configure this manually.

## Configuration

You must have a Utility instance in your called 'loadbalancer', however,
if you wish to change this, you can configure it in recipes/default.rb.

Upload the recipe to your environment and apply with the `ey recipes
upload` and `ey recipes apply`

## Notes

Please inform us if you are wanting to run this recipe, you will need to
have us attach an IP to your Utility instance, but attempting to run
this without informing support will severely impact our ability to
support your application.
