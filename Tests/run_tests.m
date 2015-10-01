function varargout = run_tests
% run all unit tests for settings handler
%
% function results = run_tests	
%
% No input arguments. Results printed to screen and optionally 
% returned to the workspace. 

testCase = settingsHandlerTest;
results = run(testCase);


if nargout>0
	varargout{1}=results;
end