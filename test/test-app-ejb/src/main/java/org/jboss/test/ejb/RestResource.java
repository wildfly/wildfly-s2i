package org.jboss.test.ejb;

import java.io.Serializable;

import jakarta.ejb.EJB;
import jakarta.enterprise.context.SessionScoped;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * @author <a href="mailto:yborgess@redhat.com">Yeray Borges</a>
 */
@Path("/")
@SessionScoped
@Produces(MediaType.TEXT_PLAIN)
public class RestResource implements Serializable {
    private static final long serialVersionUID = 1L;

    @EJB
    StatefulSessionBean sfsb;

    @GET
    @Path("/")
    public String availability() {
        return "OK";
    }

    @GET
    @Path("/messages/{message}")
    public String createNew(@PathParam(value = "message") String message) {
        return sfsb.getMessage(message);
    }
}
