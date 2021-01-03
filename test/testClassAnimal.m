classdef testClassAnimal <  matlab.unittest.TestCase
    %TESTCLASSANIMAL Tester class for the animal class
    %   Main testing class for the the animal class
    
    methods (Test)
        function simpleConstructor(testCase)
            %SIMPLECONSTRUCTOR Test instantiating a class with simple input
            %   Test creating the class with a set of simple inputs
            
            myAnimal = animal('Sheep', 'Grass');
            
            testCase.verifyNotEmpty(myAnimal)
        end
        function multiFeedConstructor(testCase)
            %MULTIFEEDCONSTRUCTOR Test instantiating a class with multiple feed
            %   Test creating the class with a set of multiple feed inputs
            
            myAnimal = animal('Sheep', ['Grass', "Trees"]);
            
            testCase.verifyNotEmpty(myAnimal)
        end
    end
end

