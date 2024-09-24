
/*
Typescript is Static Typing, but Weak Typed.
 */
var aNumber: number;

globalThis.aNumber = 100;

setTimeout(()=>{

    eval(`
        console.info("[BEFORE] aNumber type is " + typeof(globalThis.aNumber)); 
        globalThis.aNumber = "a"; 
        console.info("[AFTER] aNumber type is " + typeof(globalThis.aNumber)); 
        `)

}, 1000);

