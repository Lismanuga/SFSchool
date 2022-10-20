/**
 * Created by ADMIN on 20.10.2022.
 */

@IsTest
private class formulaOneDAOTest {
    
    @IsTest
    static void testGetDriverById() {
        FormulaOneDAO.getDriver('a027Q000003SQvNQAW');
    }
    @IsTest
    static void testGetRaceResult() {
        FormulaOneDAO.getRaceResults('a027Q000003SQvNQAW');

    }
    @IsTest
    static void testGetDriverCircuits() {
        FormulaOneDAO.getDriverCircuits('a027Q000003SQvNQAW');

    }
    @IsTest
    static void testGetYoungestDriverOnRace() {
        FormulaOneDAO.getYoungestDriverOnRace('a007Q00000BHeZtQAL');
    }
    @IsTest
    static void testGetAllDriversByCircuit() {
        FormulaOneDAO.getAllDriversByCircuit();
    }
}