
// CloudOS

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Test that files written to the working directory and put into a channel
are succesfully staged in the next process.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

greeting_ch = channel.of(params.greeting) 

process SPLITLETTERS { 
    input: 
    val(greeting) from greeting_ch

    output: 
    path "chunk_*" into split_ch
    path "hostname_splitletters" into split_host_ch

    script: 
    """
    cat <(hostname) > hostname_splitletters

    printf '${greeting}' | split -b 6 - chunk_
    """
}

split_ch
    .flatten()
    .view()
    .set { split_ch }

split_host_ch
    .view()

process CONVERTTOUPPER {
    input: 
    path(chunk) from split_ch

    script: 
    """
    hostname

    tr '[a-z]' '[A-Z]' < ${chunk} > ${chunk}_convert
    """
}
