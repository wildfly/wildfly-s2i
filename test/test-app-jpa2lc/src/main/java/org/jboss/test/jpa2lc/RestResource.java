package org.jboss.test.jpa2lc;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.UserTransaction;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * @author <a href="mailto:yborgess@redhat.com">Yeray Borges</a>
 */
@Path("/")
@RequestScoped
@Produces(MediaType.TEXT_PLAIN)
public class RestResource {

    @PersistenceContext(unitName = "MainPU")
    private EntityManager em;

    @Inject
    private UserTransaction tx;

    @GET
    @Path("/")
    public String availability() {
        return "OK";
    }

    @GET
    @Path("/create/{id}")
    public String createNew(@PathParam(value = "id") Long id) throws Exception {
        final DummyEntity entity = new DummyEntity();
        entity.setId(id);
        tx.begin();
        em.persist(entity);
        tx.commit();

        return String.format("%d created", id);
    }

    @GET
    @Path("/cache/{id}")
    public String addToCacheByQuerying(@PathParam(value = "id") Long id) {
        DummyEntity result = em.createQuery("select b from DummyEntity b where b.id=:id", DummyEntity.class)
                .setParameter("id", id)
                .getSingleResult();

        return String.format("%d found", result.getId());
    }

    @GET
    @Path("/evict/{id}")
    public String evict(@PathParam(value = "id") Long id) {
        em.getEntityManagerFactory().getCache().evict(DummyEntity.class, id);

        return String.format("%d evicted", id);
    }

    @GET
    @Path("/isInCache/{id}")
    public boolean isEntityInCache(@PathParam(value = "id") Long id) {
        return em.getEntityManagerFactory().getCache().contains(DummyEntity.class, id);
    }
}
