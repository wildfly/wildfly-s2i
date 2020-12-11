package org.jboss.test.ejb;

import java.io.Serializable;

import javax.ejb.Stateful;

/**
 * @author <a href="mailto:yborgess@redhat.com">Yeray Borges</a>
 */
@Stateful
public class StatefulSessionBean implements Serializable {
    private static final long serialVersionUID = 1L;

    public String getMessage(String message) {
        return "sfsb_"+message;
    }
}
