package org.jboss.test.jpa2lc;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.UserTransaction;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

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
