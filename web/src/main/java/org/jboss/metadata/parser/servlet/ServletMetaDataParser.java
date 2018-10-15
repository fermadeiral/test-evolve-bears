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

package org.jboss.metadata.parser.servlet;

import java.util.ArrayList;
import java.util.List;

import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.jboss.metadata.javaee.spec.DescriptionGroupMetaData;
import org.jboss.metadata.javaee.spec.ParamValueMetaData;
import org.jboss.metadata.javaee.spec.SecurityRoleRefsMetaData;
import org.jboss.metadata.parser.ee.DescriptionGroupMetaDataParser;
import org.jboss.metadata.parser.ee.ParamValueMetaDataParser;
import org.jboss.metadata.parser.ee.RunAsMetaDataParser;
import org.jboss.metadata.parser.ee.SecurityRoleRefMetaDataParser;
import org.jboss.metadata.parser.util.MetaDataElementParser;
import org.jboss.metadata.property.PropertyReplacer;
import org.jboss.metadata.web.spec.ServletMetaData;

/**
 * @author Remy Maucherat
 */
public class ServletMetaDataParser extends MetaDataElementParser {

    public static ServletMetaData parse(XMLStreamReader reader, final PropertyReplacer propertyReplacer) throws XMLStreamException {
        ServletMetaData servlet = new ServletMetaData();

        // Handle attributes
        final int count = reader.getAttributeCount();
        for (int i = 0; i < count; i++) {
            final String value = reader.getAttributeValue(i);
            if (attributeHasNamespace(reader, i)) {
                continue;
            }
            final Attribute attribute = Attribute.forName(reader.getAttributeLocalName(i));
            switch (attribute) {
                case ID: {
                    servlet.setId(value);
                    break;
                }
                default:
                    throw unexpectedAttribute(reader, i);
            }
        }

        DescriptionGroupMetaData descriptionGroup = new DescriptionGroupMetaData();
        // Handle elements
        while (reader.hasNext() && reader.nextTag() != END_ELEMENT) {
            if (DescriptionGroupMetaDataParser.parse(reader, descriptionGroup)) {
                if (servlet.getDescriptionGroup() == null) {
                    servlet.setDescriptionGroup(descriptionGroup);
                }
                continue;
            }
            final Element element = Element.forName(reader.getLocalName());
            switch (element) {
                case SERVLET_NAME:
                    servlet.setServletName(getElementText(reader, propertyReplacer));
                    break;
                case SERVLET_CLASS:
                    servlet.setServletClass(getElementText(reader, propertyReplacer));
                    break;
                case JSP_FILE:
                    servlet.setJspFile(getElementText(reader, propertyReplacer));
                    break;
                case INIT_PARAM:
                    List<ParamValueMetaData> initParams = servlet.getInitParam();
                    if (initParams == null) {
                        initParams = new ArrayList<ParamValueMetaData>();
                        servlet.setInitParam(initParams);
                    }
                    initParams.add(ParamValueMetaDataParser.parse(reader, propertyReplacer));
                    break;
                case LOAD_ON_STARTUP:
                    servlet.setLoadOnStartup(getElementText(reader, propertyReplacer));
                    break;
                case ENABLED:
                    if (Boolean.TRUE.equals(Boolean.valueOf(getElementText(reader, propertyReplacer)))) {
                        servlet.setEnabled(true);
                    } else {
                        servlet.setEnabled(false);
                    }
                    break;
                case ASYNC_SUPPORTED:
                    if (Boolean.TRUE.equals(Boolean.valueOf(getElementText(reader, propertyReplacer)))) {
                        servlet.setAsyncSupported(true);
                    } else {
                        servlet.setAsyncSupported(false);
                    }
                    break;
                case RUN_AS:
                    servlet.setRunAs(RunAsMetaDataParser.parse(reader, propertyReplacer));
                    break;
                case SECURITY_ROLE_REF:
                    SecurityRoleRefsMetaData securityRoleRefs = servlet.getSecurityRoleRefs();
                    if (securityRoleRefs == null) {
                        securityRoleRefs = new SecurityRoleRefsMetaData();
                        servlet.setSecurityRoleRefs(securityRoleRefs);
                    }
                    securityRoleRefs.add(SecurityRoleRefMetaDataParser.parse(reader, propertyReplacer));
                    break;
                case MULTIPART_CONFIG:
                    servlet.setMultipartConfig(MultipartConfigMetaDataParser.parse(reader, propertyReplacer));
                    break;
                default:
                    throw unexpectedElement(reader);
            }
        }

        return servlet;
    }

}
