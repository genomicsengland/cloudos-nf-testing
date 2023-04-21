nextflow.enable.dsl = 1

params.executor = 'awsbatch'
params.greeting = 'Hello world!'

greeting_ch = channel.of(params.greeting) 

process SPLITLETTERS { 
    input: 
    val(greeting) from greeting_ch

    output: 
    path 'chunk_*' into split_ch

    script: 
    """
    printf '${greeting}' | split -b 6 - chunk_
    """
} 

process CONVERTTOUPPER {
    input: 
    path(chunk) from split_ch.flatten()

    script: 
    """
    tr '[a-z]' '[A-Z]' < ${chunk} > ${chunk}_convert
    """
}
