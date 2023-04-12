classdef tInstall < matlab.unittest.TestCase
% Verify installation of matlab engine

    properties (Constant)
        MATLABVersion = getenv('MATLABVersion')
    end

    methods (Test)
        function installNoVersionSpecified(testCase)
		    disp(ver().Version)
            assumeEqual(testCase, testCase.MATLABRelease, '9.14')
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