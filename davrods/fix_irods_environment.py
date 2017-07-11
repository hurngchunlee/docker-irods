#!/usr/bin/env python

import json
import sys
import os

if __name__ == '__main__':

    fname = '/etc/httpd/irods/irods_environment.json'

    if os.path.exists(fname):
        # readin JSON file
        f = open(fname, 'r')
        cfg = json.load(f)
        f.close()

        # modify attributes
        cfg['irods_host'] = os.environ['IRODS_ICAT_HOST']
        cfg['irods_port'] = int(os.environ['IRODS_ZONE_PORT'])
        cfg['irods_zone_name'] = os.environ['IRODS_ZONE_NAME']
        cfg['irods_user_name'] = 'irods'
        cfg['irods_default_resource'] = ''

        # write JSON file back
        f = open(fname, 'w')
        json.dump(cfg, f, sort_keys=True, indent=4, separators=(',', ': '))
        f.close()

    else:
        print(sys.stderr, "file not found: %s" % fname)
        sys.exits(1)
