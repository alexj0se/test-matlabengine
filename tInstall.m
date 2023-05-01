classdef tInstall < matlab.unittest.TestCase
% Verify installation of matlab engine

% Copyright 2023 Mathworks, Inc.
    properties (Constant)
        MATLABVersion = string(ver('MATLAB').Version)
        MATLABRelease = erase(ver('MATLAB').Release,{'(',')'})
    end

    methods (Test)
        function installNoVersionSpecified(testCase)
            assumeEqual(testCase, testCase.MATLABRelease, 'R2023a')
            [status, out] = system("pip install matlabengine");
            verifyEqual(testCase, status, 0, out)
            verifyInstallation(testCase)
        end

        function installMatchingEngine(testCase)
            [status, out] = system("pip install matlabengine==" + testCase.MATLABVersion + ".*");
            verifyEqual(testCase, status, 0, out)
            verifyInstallation(testCase)
        end

        function installEarlierEngine(testCase)
            earlierVersion = extractBefore(testCase.MATLABVersion, '.') + "." + ...
                (str2double(extractAfter(testCase.MATLABVersion, '.')) - 1) + ".*";
            [status, out] = system("pip install matlabengine==" + earlierVersion);
            verifyNotEqual(testCase, status, 0, "Install must fail. Output:" + newline + out)
        end
    end

    methods
        function verifyInstallation(testCase)
        % Verify installation by calling functions in matlab engine
        % Share this session and see if find_matlab can find it.
            sharedEngineName = string(matlab.engine.engineName);
            if (sharedEngineName == "")
                sharedEngineName = "MATLAB_tInstall";
                matlab.engine.shareEngine(sharedEngineName)
            end
            pySharedEngineName = string(py.matlab.engine.find_matlab());
            verifyEqual(testCase, pySharedEngineName, sharedEngineName)
            system("pip uninstall -y matlabengine")
        end
    end
end