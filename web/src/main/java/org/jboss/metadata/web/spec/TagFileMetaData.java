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
package org.jboss.metadata.web.spec;

import java.util.List;

import org.jboss.metadata.javaee.support.NamedMetaDataWithDescriptionGroup;

/**
 * taglib/tag-file metadata
 *
 * @author Remy Maucherat
 * @version $Revision: 75201 $
 */
public class TagFileMetaData extends NamedMetaDataWithDescriptionGroup {
    private static final long serialVersionUID = 1;

    private String path;
    private List<String> examples;
    private List<TldExtensionMetaData> tagExtensions;

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public List<String> getExamples() {
        return examples;
    }

    public void setExamples(List<String> examples) {
        this.examples = examples;
    }

    public List<TldExtensionMetaData> getTagExtensions() {
        return tagExtensions;
    }

    public void setTagExtensions(List<TldExtensionMetaData> tagExtensions) {
        this.tagExtensions = tagExtensions;
    }

    public String toString() {
        StringBuilder tmp = new StringBuilder("TagFileMetaData(id=");
        tmp.append(getId());
        tmp.append(",path=");
        tmp.append(path);
        tmp.append(')');
        return tmp.toString();
    }
}
