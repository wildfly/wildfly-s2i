/*
 * JBoss, Home of Professional Open Source
 * Copyright 2015, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.wildfly.plugins.demo.tasksrs.model;

import jakarta.enterprise.context.RequestScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Provides functionality for manipulation with products using persistence context
 * from {@link Resources}.
 *
 * @author Jose Mayorga
 */
@RequestScoped
public class ProductDaoImpl implements ProductDao {

    @PersistenceContext(type = PersistenceContextType.EXTENDED, unitName = "secondary")
    private static EntityManager em;

    public Product getForName(String name) {
        List<Product> result =
                em.createQuery("select u from Product u where u.name = ?1", Product.class)
                        .setParameter(1, name)
                        .getResultList();

        if (result.isEmpty()) {
            return null;
        }
        return result.get(0);
    }

    @Override public List<Product> getAll() {
        TypedQuery<Product> query = em.createQuery("SELECT p FROM Product p", Product.class);
        return query.getResultList();
    }

    public void createProduct(Product product) {
        em.persist(product);
    }
}
