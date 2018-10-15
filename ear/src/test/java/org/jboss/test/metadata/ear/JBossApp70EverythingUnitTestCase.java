/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2013, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

package org.jboss.test.metadata.ear;

import org.jboss.metadata.ear.jboss.JBossAppMetaData;
import org.jboss.metadata.ear.jboss.ServiceModuleMetaData;
import org.jboss.metadata.ear.spec.ConnectorModuleMetaData;
import org.jboss.metadata.ear.spec.EarMetaData;
import org.jboss.metadata.ear.spec.EjbModuleMetaData;
import org.jboss.metadata.ear.spec.JavaModuleMetaData;
import org.jboss.metadata.ear.spec.ModuleMetaData;
import org.jboss.metadata.ear.spec.ModulesMetaData;
import org.jboss.metadata.ear.spec.WebModuleMetaData;
import org.jboss.metadata.javaee.spec.SecurityRoleMetaData;
import org.jboss.metadata.javaee.spec.SecurityRolesMetaData;
import org.jboss.metadata.ear.merge.JBossAppMetaDataMerger;
import org.jboss.metadata.ear.parser.jboss.JBossAppMetaDataParser;
import org.jboss.metadata.ear.parser.spec.EarMetaDataParser;
import org.jboss.test.metadata.javaee.AbstractJavaEEMetaDataTest;
import org.junit.Test;

/**
 * Test jboss-app.xml which uses jboss-app_7_1.xsd
 *
 * @author Jaikiran Pai
 */
public class JBossApp70EverythingUnitTestCase extends AbstractJavaEEMetaDataTest {

    private boolean hasJBossAppOverride = false;

    protected JBossAppMetaData unmarshal() throws Exception {
        return JBossAppMetaDataParser.INSTANCE.parse(getReader());
    }

    @Test
    public void testOverride() throws Exception {
        EarMetaData spec = EarMetaDataParser.INSTANCE.parse(getReader("Ear6xEverything_testEverything.xml"));
        JBossAppMetaData jbossAppMD = new JBossAppMetaData();
        JBossAppMetaDataMerger.merge(jbossAppMD, null, spec);
        hasJBossAppOverride = false;
        assertEveryting(jbossAppMD);
    }

    @Test
    public void testEverything()
            throws Exception {
        //enableTrace("org.jboss.xb");
        EarMetaData spec = EarMetaDataParser.INSTANCE.parse(getReader("Ear6xEverything_testEverything.xml"));
        JBossAppMetaData jbossAppXml = unmarshal();
        assertEquals("Unexpected distinct-name", "foo", jbossAppXml.getDistinctName());
        JBossAppMetaData jbossAppMD = new JBossAppMetaData();
        JBossAppMetaDataMerger.merge(jbossAppMD, jbossAppXml, spec);
        hasJBossAppOverride = true;
        assertEveryting(jbossAppMD);
        assertEquals("jboss-app-id", jbossAppMD.getId());
        assertEveryting(jbossAppMD);
    }

    protected void assertEveryting(JBossAppMetaData ear) throws Exception {
        assertSecurityRoles(ear);
        assertLibraryDirectory(ear);
        assertModules(ear);
    }

    protected void assertSecurityRoles(JBossAppMetaData ear) {
        SecurityRolesMetaData roles = ear.getSecurityRoles();
        assertEquals("There are 2 roles", 2, roles.size());
        SecurityRoleMetaData role0 = roles.get("role0");
        assertEquals("security-role0", role0.getId());
        assertEquals("role0", role0.getName());
        assertEquals("The 0 security role", role0.getDescriptions().value()[0].value());
        SecurityRoleMetaData role1 = roles.get("role1");
        assertEquals("security-role1", role1.getId());
        assertEquals("role1", role1.getName());
        assertEquals("The 1 security role", role1.getDescriptions().value()[0].value());
        if (hasJBossAppOverride) {
            assertTrue("1 principal in role0", role0.getPrincipals().size() == 1);
            assertEquals("principal0", role0.getPrincipals().toArray()[0]);
            assertEquals("principal1", role1.getPrincipals().toArray()[0]);
        }
    }

    protected void assertLibraryDirectory(JBossAppMetaData ear) {
        if (hasJBossAppOverride)
            assertEquals("jboss-app-lib0", ear.getLibraryDirectory());
        else
            assertEquals("lib0", ear.getLibraryDirectory());
    }

    protected void assertModules(JBossAppMetaData ear) {
        ModulesMetaData modules = ear.getModules();
        if (hasJBossAppOverride)
            assertEquals(9, modules.size());
        else
            assertEquals(6, modules.size());
        ModuleMetaData connector = modules.get(0);
        assertEquals("connector0", connector.getId());
        ConnectorModuleMetaData connectorMD = (ConnectorModuleMetaData) connector.getValue();
        assertEquals("rar0.rar", connectorMD.getConnector());
        ModuleMetaData java = modules.get(1);
        assertEquals("java0", java.getId());
        JavaModuleMetaData javaMD = (JavaModuleMetaData) java.getValue();
        assertEquals("client0.jar", javaMD.getClientJar());
        ModuleMetaData ejb0 = modules.get(2);
        assertEquals("ejb0", ejb0.getId());
        EjbModuleMetaData ejb0MD = (EjbModuleMetaData) ejb0.getValue();
        assertEquals("ejb-jar0.jar", ejb0MD.getEjbJar());
        ModuleMetaData ejb1 = modules.get(3);
        assertEquals("ejb1", ejb1.getId());
        EjbModuleMetaData ejb1MD = (EjbModuleMetaData) ejb1.getValue();
        assertEquals("ejb-jar1.jar", ejb1MD.getEjbJar());
        ModuleMetaData web0 = modules.get(4);
        assertEquals("web0", web0.getId());
        WebModuleMetaData web0MD = (WebModuleMetaData) web0.getValue();
        assertEquals("/web0", web0MD.getContextRoot());
        assertEquals("web-app0.war", web0MD.getWebURI());
        ModuleMetaData web1 = modules.get(5);
        assertEquals("web1", web1.getId());
        WebModuleMetaData web1MD = (WebModuleMetaData) web1.getValue();
        if (hasJBossAppOverride)
            assertEquals("/web1-override", web1MD.getContextRoot());
        else
            assertEquals("/web1", web1MD.getContextRoot());
        assertEquals("web-app1.war", web1MD.getWebURI());
        if (hasJBossAppOverride) {
            // Validate the sar, web2, har added in jboss-app.xml
            ModuleMetaData sar = modules.get(6);
            assertEquals("sar0", sar.getId());
            ServiceModuleMetaData sarMD = (ServiceModuleMetaData) sar.getValue();
            assertEquals("sar0.sar", sarMD.getSar());
            ModuleMetaData web2 = modules.get(7);
            assertEquals("web2", web2.getId());
            WebModuleMetaData web2MD = (WebModuleMetaData) web2.getValue();
            assertEquals("/web2", web2MD.getContextRoot());
            assertEquals("web-app2.war", web2MD.getWebURI());
            ModuleMetaData har = modules.get(8);
            assertEquals("har0", har.getId());
            ServiceModuleMetaData harMD = (ServiceModuleMetaData) har.getValue();
            assertEquals("har0.har", harMD.getSar());
        }
        // Validate lookup by module file name
        ModuleMetaData mmd = modules.get("rar0.rar");
        assertEquals(connector, mmd);
        mmd = modules.get("ejb-jar1.jar");
        assertEquals(ejb1, mmd);
        mmd = modules.get("web-app0.war");
        assertEquals(web0, mmd);
    }
}
