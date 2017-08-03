#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# This file is part of PyZenKit package.
#
# Copyright (C) since 2016 CESNET, z.s.p.o (http://www.ces.net/)
# Copyright (C) since 2015 Jan Mach <honza.mach.ml@gmail.com>
# Use of this package is governed by the MIT license, see LICENSE file.
#
# This project was initially written for personal use of the original author. Later
# it was developed much further and used for project of author`s employer.
#-------------------------------------------------------------------------------

import unittest
from unittest.mock import Mock, MagicMock, call
from pprint import pformat, pprint

import os
import sys
import shutil

# Generate the path to custom 'lib' directory
lib = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../'))
sys.path.insert(0, lib)

import pyzenkit.baseapp
import pyzenkit.zendaemon

#
# Global variables
#
DMN_NAME       = 'test-zendaemon.py'              # Name of the daemon process
JSON_FILE_NAME = '/tmp/daemon-state.json'         # Name of the test JSON file
CFG_FILE_NAME  = '/tmp/{}.conf'.format(DMN_NAME)  # Name of the daemon configuration file
CFG_DIR_NAME   = '/tmp/{}'.format(DMN_NAME)       # Name of the daemon configuration directory

class TestPyzenkitZenDaemon(unittest.TestCase):

    def setUp(self):
        pyzenkit.baseapp.BaseApp.json_save(CFG_FILE_NAME, {'test': 'x'})
        try:
            os.mkdir(CFG_DIR_NAME)
        except FileExistsError:
            pass

        self.obj = pyzenkit.zendaemon.DemoZenDaemon(name = DMN_NAME)

    def tearDown(self):
        os.remove(CFG_FILE_NAME)
        shutil.rmtree(CFG_DIR_NAME)

    def test_01_basic(self):
        """
        Perform the basic operativity tests.
        """
        self.assertTrue(True)

if __name__ == "__main__":
    unittest.main()
