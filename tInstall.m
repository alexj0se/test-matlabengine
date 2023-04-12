classdef tInstall < matlab.unittest.TestCase
% Verify installation of matlab engine

    properties (Constant)
        MATLABVersion = string(ver('MATLAB').Version)
        MATLABRelease = erase(ver('MATLAB').Release,{'(',')'})
    end

    methods (Test)
        function installNoVersionSpecified(testCase)
            assumeEqual(testCase, testCase.MATLABRelease, 'R2023a')
            [status, out] = system("pip install matlabengine")
			verifyEqual(testCase, status, 0);

        end

        function installMatchingEngine(testCase)
            [status, out] = system("pip install matlabengine==" + testCase.MATLABVersion + ".*")
			verifyEqual(testCase, status, 0);
        end

        function installEarlierEngine(testCase)
            earlierVersion = extractBefore(testCase.MATLABVersion, '.') + "." + ...
                (str2num(extractAfter(testCase.MATLABVersion, '.')) - 1) + ".*";
            [status, out] = system("pip install matlabengine==" + earlierVersion)
			verifyNotEqual(testCase, status, 0, "Install must fail");
        end
    end

end