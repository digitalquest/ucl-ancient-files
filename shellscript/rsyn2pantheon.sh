export ENV=dev
# Usually dev, test, or live
export SITE=2aac846a-be06-4d04-ad83-0148a4d7d4fe
# Site UUID from dashboard URL: https://dashboard.pantheon.io/sites/<UUID>

# To Upload/Import
rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./uploads/* --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:files/

# To Download
#rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE@appserver.$ENV.$SITE.drush.in:files/ ~/files


# -r: Recurse into subdirectories
# -l: Check links
# -v: Verbose output
# -z: Compress during transfer
# Other rsync flags may or may not be supported
# (-a, -p, -o, -g, -D, etc are not).