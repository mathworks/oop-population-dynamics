classdef testClassPlant <  matlab.unittest.TestCase
    %TESTCLASSPLANT Tester class for the plant class
    %   Main testing class for the the plant class
    
    methods (Test)
        function simpleConstructor(testCase)
            %SIMPLECONSTRUCTOR Test instantiating a class with simple input
            %   Test creating the class with a set of simple inputs
            
            myPlant = animal('Grass', 'Earth');
            
            testCase.verifyNotEmpty(myPlant)
        end
    end
end

