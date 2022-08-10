package org.jboss.test.jpa2lc;

import java.io.Serializable;

import jakarta.persistence.Cacheable;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

/**
 * @author <a href="mailto:yborgess@redhat.com">Yeray Borges</a>
 */
@Entity
@Cacheable
public class DummyEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "DummyEntity{" +
                "id=" + id +
                '}';
    }
}
