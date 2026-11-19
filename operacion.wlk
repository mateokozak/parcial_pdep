class Causas {
    const property caratula
    const jueces = []
    var property montoBase

    method perjuicioTotal() = montoBase + self.montoExtra()
    method montoExtra()
    method hayJuecesArrepentidos() = jueces.any({juez => juez.estaArrepentido()})
    method totalJueces() = jueces.length()
    method esTramboliko() = self.perjuicioTotal() > 5
    method aumentarMontoBase(criterio) {
        montoBase += criterio
    }
}

class Juez {
    const property nombre
    var property estaArrepentido
}

class Soborno inherits Causas {
    override method montoExtra() = if (self.hayJuecesArrepentidos()) 2 else 1
}

class ObraPublica inherits Causas {
    override method montoExtra() = if (self.totalJueces() <= 2) 2 else 0
}

class Complejas inherits Causas { 
    const causas = []


    override method montoExtra() = causas.sum({causa => causa.perjuicioTotal()})
}

class Funcionarios {
    const causas = []
    const property patrimonio
    const promesas = []
    const property fechaHoy = new Date()

    method validarPatrimonio() = patrimonio > 0
    method causasQueTeDejanPegado() = causas.filter({causa => causa.esTramboliko()})
    method salirEnMedios() {
        causas.forEach({causa => causa.aumentarMontoBase(0.1)})
    }

    method puedeComerseUnaCausa(causa)
    method incorporarCausa(causa) {
        if (self.puedeComerseUnaCausa(causa)) causas.add(causa)
        else throw new DomainException(message = "No se cumplen los requisitos para incorporar la causa")
    }
    method escucharPropuesta(propuesta) {
        if(self.validarPropuesta(propuesta)) self.aceptarPropuesta(propuesta)
        else self.rechazarPropuesta(propuesta)
    }
    method aceptarPropuesta(propuesta) {
        promesas.add(new Promesa(descripcion = propuesta.descripcion(), fechaPresentacion = propuesta.fechaPresentacion(), fechaCumplimiento = propuesta.fechaCumplimiento()))
    }
    method rechazarPropuesta(propuesta) {
        const fechaCumplimiento = new Date(year = self.fechaHoy().year() + 4, month = self.fechaHoy().month(), day = self.fechaHoy().day())
        promesas.add(new Promesa(descripcion = propuesta.descripcion(), fechaPresentacion = propuesta.fechaPresentacion(), fechaCumplimiento = fechaCumplimiento))
    }
    method validarPropuesta(propuesta)
}

class PoderEjecutivo inherits Funcionarios {
    const juecesAmigos = []
    const palabrasClave = ["aumento", "impuestos", "inflación"]

    method tieneJuezAmigo(causa) = causa.jueces().any({ juez => juecesAmigos.contains(juez) })

    override method puedeComerseUnaCausa(causa) = self.validarPatrimonio() && self.tieneJuezAmigo(causa)

    override method validarPropuesta(propuesta) = palabrasClave.any({ palabra => propuesta.descripcion().contains(palabra) })
}

class Ministros inherits Funcionarios { 
    override method puedeComerseUnaCausa(causa) = self.validarPatrimonio() && causa.perjuicioTotal() * 0.5 < patrimonio

    override method validarPropuesta(propuesta) = propuesta.fechaCumplimiento().year() - propuesta.fechaPresentacion().year() < 1
}

class Propuesta {
    const property descripcion
    const property fechaPresentacion
    var property fechaCumplimiento
}

class Promesa {
    const property descripcion
    const property fechaPresentacion
    var property fechaCumplimiento
}