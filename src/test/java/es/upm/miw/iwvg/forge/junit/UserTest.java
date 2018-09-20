package es.upm.miw.iwvg.forge.junit;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

public class UserTest {

    private User user;

    @BeforeEach
    void beforeEach() {
        user = new User(1, "Tomy", "Gutierrez");
    }

    @Test
    void testFullName() {
        assertEquals("Tomy Gutierrez", this.user.fullName());
        User u = new User(0, null, null);
        u.fullName();
    }

    @Test
    void testInitials() {
        assertEquals("T.", this.user.initials());
    }

    @Test
    void testNumber() {
        assertEquals(1, this.user.getNumber());
    }

    @Test
    void testFamilyName() {
        assertEquals("Gutierrez", this.user.getFamilyName());
    }

    @Test
    void testNameToUpperCase() {
        User user = new User(1, "Tomy", "Gutierrez");
        user.nameToUpperCase();

        assertEquals("TOMY", user.getName());
    }

    @Test
    void testNameToUpperCaseWhenNameIsNull() {
        User user = new User(0, null, null);
        user.nameToUpperCase();

        assertNull(user.getName());
    }

}
