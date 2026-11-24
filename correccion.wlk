class Causa {
    var montoBase
    const jueces = []

    method perjuicioTotal() = montoBase + self.montoExtra()
    method montoExtra()
    method tieneJuez(juez) = jueces.contains(juez)
    method tieneMuchosJueces() = jueces.size() > 2
    method esTramboliko() = self.perjuicioTotal() > 5
    method aumentarMontoBase(monto) {
        montoBase += monto
    }
}

class Soborno inherits Causa {
    var hayArrepentidos

    method arrepentirse() {
        hayArrepentidos = true
    }
    method hacerseElGil() {
        hayArrepentidos = false
    }

    override method montoExtra() = if (hayArrepentidos) 2 else 1
}

class ObraPublica inherits Causa(montoBase = 3) {
    override method montoExtra() = if (self.tieneMuchosJueces()) 0 else 2
}

class Compleja inherits Causa {
    const subcausas = []
    override method montoExtra() = subcausas.sum({causa => causa.montoExtra()})
    method agregarCausa(causa) {
        subcausas.add(causa)
    }
}

class Funcionario {
    const causas = #{}
    var property puesto
    var patrimonio

    method tienePatrimonio() = patrimonio > 0

    method comerseCausa(causa) {
        self.validarMonto()
        puesto.validar(causa, self)
        causas.add(causa)
    }

    method validarMonto() {
        if (!self.tienePatrimonio()){
            throw new DomainException(message = "No tiene patrimonio")
        }
    }

    method causasQueTeDejanPegado() = causas.filter({causa => causa.esTramboliko()})
    method salirEnLosMedios() {
        causas.forEach({causa => causa.aumentarMontoBase(0.1)})
    }
}

class PoderEjecutivo {
    var juezAmigo
    const palabrasClave = []

    method validar(causa, funcionario) { 
        if(!causa.tieneJuez(juezAmigo)) {
            throw new DomainException(message = "No tiene juez amigo")
        }
    }

    method aceptaPropuesta(propuesta) = palabrasClave.any({palabra => propuesta.contieneEnDescripcion(palabra)})
} 

object ministro {
    method validar(causa, funcionario) {
        if (!funcionario.patrimonio() > causa.perjuicioTotal() * 0.5) {
            throw new DomainException(message = "No tiene patrimonio suficiente")
        }
    }

    method aceptaPropuesta(propuesta) = propuesta.esCorta()
}

class Propuesta {
    const fechaPresentacion
    var fechaCumplimiento
    const descripcion

    method fechaCumplimiento() = fechaCumplimiento

    method postergar() {
        fechaCumplimiento = fechaCumplimiento.plusYears(4)
    }

    method contieneEnDescripcion(palabra) = descripcion.contains(palabra)

    method esCorta() = fechaCumplimiento < fechaPresentacion.plusYears(1)
}

