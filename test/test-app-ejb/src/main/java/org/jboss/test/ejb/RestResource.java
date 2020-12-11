package org.jboss.test.ejb;

import java.io.Serializable;

import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

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
