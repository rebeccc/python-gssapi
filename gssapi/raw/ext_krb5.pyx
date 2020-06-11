GSSAPI="BASE"  # This ensures that a full module is generated by Cython 

from gssapi.raw.cython_types cimport *

from gssapi.raw.misc import GSSError

cdef extern from "python_gssapi_krb5.h":
    OM_uint32 gss_krb5_ccache_name(OM_uint32 *minor_status, 
                                   const char *name,
                                   const char **out_name) nogil

    OM_uint32 gss_krb5_copy_ccache(OM_uint32 *minor_status,
                                   gss_cred_id_t cred_handle,
                                   krb5_ccache out_ccache) nogil

    OM_uint32 gss_krb5_set_allowable_enctypes(OM_uint32 *minor_status,
                                              gss_cred_id_t cred,
                                              OM_uint32 num_ktypes,
                                              krb5_enctype *ktypes) nogil

    
    OM_uint32 gss_krb5_get_tkt_flags(OM_uint32 *minor_status,
                                     gss_ctx_id_t context_handle,
                                     krb5_flags *ticket_flags) nogil

    # GSS_KRB_NT_PRINCIPAL_NAME is defined in enum ext file

def krb5_ccache_name(name is not none, out_name):
    """
    krb5_ccache_name(name, out_name)
    
    Sets a new name for credentials cache

    Args:
        name (char*): New name for the ccache
        out_name (char**): Can either be the current ccache name or None if it has not been set yet. 
                           Specify None if the current ccache name is not needed.
    Returns:
        None
    Raises:
        GSSError
    """

    cdef OM_uint32 min_stat, maj_stat
    
    with nogil:
        maj_stat = gss_krb5_ccache_name(&min_stat, <char*>name, <char**>out_name)

    if maj_stat == GSS_S_COMPLETE:
        return
    else:
        raise GSSError(maj_stat, min_stat)

def krb5_copy_ccache(Creds cred_handle not None, #out ccache):
    """
    krb5_copy_ccache(cred_handle, out_ccache)

    Copy tickets associated with the inputted credentials into the specified ccache
    
    Args:
        cred_handle (Creds): GSS-API credential handle
        out_ccache (): The target ccache
    Returns:
        None
    Raises:
        GSSError
    """

    cdef OM_uint32 min_stat, maj_stat

    if maj_stat == GSS_S_COMPLETE:
        return
    else:
        raise GSSError(maj_stat, min_stat)

def krb5_get_tkt_flags(SecurityContext context not None, #krb5_flags *ticket_flags):
    """
    krb5_get_tkt_flags(context, tkt_flags)
    
    Returns ticket flags associated with specified security context

    Args:
        context (SecurityContext): The handle for the Security Context
        tkt_flags (krb5_flags): The ticket flags from the Kerberos ticket associated with the security context
    Returns:
        Ticket flags
    Raises:
        GSSError
    """

    cdef OM_uint32 min_stat, maj_stat

    if maj_stat == GSS_S_COMPLETE:
        return
    else:
        raise GSSError(maj_stat, min_stat)

def set_allowable_enctypes(Creds cred, num_ktypes, #krb5_enctype *ktypes):
    """
    set_allowable_enctypes()
    
    This function may be called by a context initiator after calling
    gss_acquire_cred(), but before calling gss_init_sec_context(),
    to restrict the set of enctypes which will be negotiated during
    context establishment to those in the provided array.

    Args:
        creds (Creds): 
        num_ktypes (int): 
        kytpes (krb5_enctype):
        
    Returns:
        
    Raises:
        GSSError
    """

    cdef OM_uint32 min_stat, maj_stat

    maj_stat = gss_set_cred_option(min_stat, &cred, (gss_OID)&req_oid, &req_buffer);
    
    if maj_stat == GSS_S_COMPLETE:
        return
    else:
        raise GSSError(maj_stat, min_stat)
