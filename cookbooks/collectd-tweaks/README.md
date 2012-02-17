## Collectd Tweaks

Tweak your disk space alert limits

## Installation

To install this, you will need to add the following to cookbooks/main/recipes/default.rb:

    require_recipe "collectd-tweaks"
    
Make sure this and any customizations to the recipe are committed to your own fork of this 
repository.

## Usage

    collectd_disk_alert do
      disk :data
      warning '1572864000.0'
      failure '524288000.0'
    end

limits are specified in bytes.
