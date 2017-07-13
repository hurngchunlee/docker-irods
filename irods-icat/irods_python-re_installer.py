#!/usr/bin/env python

import json
import sys
import os

if __name__ == '__main__':

    fname = '/etc/irods/server_config.json'

    if os.path.exists(fname):
        # readin server_config.json
        f = open(fname,'r')
        cfg = json.load(f)
        f.close()

        # add python rule engine
        re_cfg = {
            "instance_name": "irods_rule_engine_plugin-python-instance",
            "plugin_name": "irods_rule_engine_plugin-python",
            "plugin_specific_configuration": {}
        }
        cfg['plugin_configuration']['rule_engines'].append(re_cfg)

        # backup original file
        os.rename(fname, fname + '.org')

        # write out the new configuration to server_config.json
        f = open(fname, 'w')
        json.dump(cfg, f, sort_keys=True, indent=4, separators=(',', ': '))
        f.close()

        # copy the core.py.template to core.py
        # - it is required for iRODS server to run properly
        if os.path.exists('/etc/irods/core.py.template'):
            os.rename('/etc/irods/core.py.template', '/etc/irods/core.py')
        else:
            # make a fake core.py
            f = open('/etc/irods/core.py')
            f.write('def hello(callback, rei):\n')
            f.write('    callback.writeLine("serverLog","hello")\n')
            f.close()
    else:
        pass
