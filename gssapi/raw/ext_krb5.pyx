GSSAPI="BASE"  # This ensures that a full module is generated by Cython 

from gssapi.raw.cython_types cimport *
from gssapi.raw.cython_converters cimport c_make_oid

from gssapi.raw.misc import GSSError

cdef extern from "python_gssapi_krb5.h":
    OM_uint32 gss_krb5_ccache_name(OM_uint32 *minor_status, 
                                   const char *name,
                                   const char **out_name) nogil

    OM_uint32 gss_krb5_set_allowable_enctypes(OM_uint32 *minor_status,
                                              gss_cred_id_t cred,
                                              OM_uint32 num_ktypes,
                                              krb5_enctype *ktypes) nogil

    gss_oid GSS_KRB_NT_PRINCIPAL_NAME

gsstypes.NameType.composite_export = c_make_oid(GSS_KRB_NT_PRINCIPAL_NAME)

def krb5_ccache_name(name is not none):
    """
    krb5_ccache_name(name, out_name)
    
    Sets a new name for credentials cache

    Args:
        name (char*): New name for the ccache
    Returns:
        out_name;
    Raises:
        GSSError
    """

    cdef OM_uint32 min_stat, maj_stat
    
    with nogil:
        maj_stat = gss_krb5_ccache_name(&min_stat, <char*>name, out_name)

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
