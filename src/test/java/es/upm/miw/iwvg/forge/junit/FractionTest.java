package es.upm.miw.iwvg.forge.junit;

import org.apache.logging.log4j.LogManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class FractionTest {

    private Fraction fraction;
    private Fraction propiaFraction;

    @BeforeEach
    void beforeEach() {
        this.fraction = new Fraction(10, 2);
        this.propiaFraction = new Fraction(1, 5);
    }

    @Test
    void testDecimal() {
        assertEquals(5, this.fraction.decimal());
    }

    @Test
    void testNumerador() {
        assertEquals(10, this.fraction.getNumerator());
    }

    @Test
    void testDenominador() {
        assertEquals(2, this.fraction.getDenominator());
    }

    @Test
    void divisionByZero() {
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> new Fraction(10, 0).decimal());
        LogManager.getLogger(this.getClass()).debug(exception.getMessage());
    }

    @Test
    void testIsPropia() {
        assertEquals(true, this.propiaFraction.isPropia());
        assertEquals(false, this.fraction.isPropia());
    }

    @Test
    void testIsEquivalent() {
        assertTrue(new Fraction(1, 2).isEquivalent(new Fraction(2, 4)));
    }

    @Test
    void testIsNotEquivalent() {
        assertFalse(new Fraction(1, 2).isEquivalent(new Fraction(3, 4)));
    }

    @Test
    void testIsImpropia() {
        assertTrue(new Fraction(10, 2).isImpropia());
    }

    @Test
    void testIsNotImpropia() {
        assertFalse(new Fraction(2, 10).isImpropia());
    }

    @Test
    void testIsImpropiaArithmeticExceptionIfEmpty() {
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> new Fraction(10, 0).isImpropia());
        LogManager.getLogger(this.getClass()).debug(exception.getMessage());
    }

}
