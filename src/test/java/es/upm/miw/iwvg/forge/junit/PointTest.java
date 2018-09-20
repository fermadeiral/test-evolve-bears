package es.upm.miw.iwvg.forge.junit;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PointTest {
    private Point point;
    private Point secondPoint;
    private Point thirdPoint;

    @BeforeEach
    void before() {
        point = new Point(2, 3);
        secondPoint = new Point(1, 2);
        thirdPoint = new Point(5,7);
    }

    @Test
    void testPointIntInt() {
        assertEquals(2, point.getX());
        assertEquals(3, point.getY());
    }

    @Test
    void testPointInt() {
        point = new Point(2);
        assertEquals(2, point.getX());
        assertEquals(2, point.getY());
    }

    @Test
    void testPoint() {
        point = new Point();
        assertEquals(0, point.getX());
        assertEquals(0, point.getY());
    }


    @Test
    void testModule() {
        assertEquals(3.6055, point.module(), 10e-5);
    }

    @Test
    void testPhase() {
        assertEquals(0.9828, point.phase(), 10e-5);
    }

    @Test
    void testTranslateOrigin() {
        this.point.translateOrigin(new Point(1, 1));
        assertEquals(1, point.getX());
        assertEquals(2, point.getY());
    }

    @Test
    void testSetCoorX(){
        this.secondPoint.setX(3);
        assertEquals(3, this.secondPoint.getX());
    }

    @Test
    void testSetCoorY() {
        this.thirdPoint.setY(4);
        assertEquals(4,this.thirdPoint.getY());
    }

}
