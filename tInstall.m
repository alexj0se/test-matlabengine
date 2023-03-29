classdef tInstall < matlab.unittest.TestCase

    methods (Test)
        function install(testCase)
            [status, out] = system("pip install matlabengine")
        end
    end
end