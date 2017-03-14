#!/usr/bin/python3
# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Copyright (C) since 2016 Jan Mach <honza.mach.ml@gmail.com>
#                          Pavel Kacha <ph@rook.cz>
# Use of this source is governed by the MIT license, see LICENSE file.
#-------------------------------------------------------------------------------

import unittest
from unittest.mock import Mock, MagicMock, call
from pprint import pformat, pprint

import os
import sys
import shutil
import signal

# Generate the path to custom 'lib' directory
lib = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../'))
sys.path.insert(0, lib)

import pyzenkit.daemonizer

PID_FILE = '/tmp/test.pyzenkit.daemonizer.pid'

class TestPyzenkitDaemonizer(unittest.TestCase):

    def setUp(self):
        pass
    def tearDown(self):
        pass

    def test_01_basic(self):
        """
        Perform the basic operativity tests.
        """
        self.assertRaises(FileNotFoundError, pyzenkit.daemonizer.write_pid, '/bogus/file', 123)
        self.assertRaises(Exception, pyzenkit.daemonizer.write_pid, '/bogus/file', "123")

        self.assertFalse(os.path.isfile(PID_FILE))
        pyzenkit.daemonizer.write_pid(PID_FILE, 12345)
        self.assertTrue(os.path.isfile(PID_FILE))
        self.assertEqual(pyzenkit.daemonizer.read_pid(PID_FILE), 12345)
        os.unlink(PID_FILE)
        self.assertFalse(os.path.isfile(PID_FILE))

    def test_02_daemonization_lite(self):
        """
        Perform lite daemonization tests.
        """
        def hnd_sig_hup(signum, frame):
            print("Received signal HUP")
        def hnd_sig_usr1(signum, frame):
            print("Received signal USR1")
        def hnd_sig_usr2(signum, frame):
            print("Received signal USR2")

        self.assertFalse(os.path.isfile(PID_FILE))
        (pid, pidfile) = pyzenkit.daemonizer.daemonize_lite(
                work_dir = '/tmp',
                pidfile = PID_FILE,
                signals = {
                    signal.SIGHUP:  hnd_sig_hup,
                    signal.SIGUSR1: hnd_sig_usr1,
                    signal.SIGUSR2: hnd_sig_usr2,
                },
            )
        self.assertTrue(os.path.isfile(PID_FILE))
        self.assertTrue(os.path.isfile(pidfile))
        self.assertEqual(pyzenkit.daemonizer.read_pid(PID_FILE), pid)
        self.assertEqual(pyzenkit.daemonizer.read_pid(pidfile), pid)
        self.assertEqual(os.getcwd(), '/tmp')


if __name__ == "__main__":
    unittest.main()
