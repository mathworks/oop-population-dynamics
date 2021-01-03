clear all %#ok<CLALL>
close all
clc

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageReport
import matlab.unittest.plugins.TestReportPlugin;

testAnimal = TestSuite.fromClass(?testClassAnimal);
testPlant = TestSuite.fromClass(?testClassPlant);
suite = [testAnimal, testPlant];
runner = TestRunner.withNoPlugins;
runner.addPlugin(CodeCoveragePlugin.forFolder(fullfile(pwd, '..', filesep), ...
   'Producing',CoverageReport('testResults','MainFile','index.html'), ...
   'IncludingSubfolders', true));
runner.addPlugin(TestReportPlugin.producingHTML('testReports'))
runner.run(suite)