class Personaje {
  const property fuerza
  const inteligencia
  var rol


  method cambiarRol(unRol) {
    rol = unRol
    }

   method potencialOfensivo() {
    return
    fuerza * 10 + rol.extra()
   }
   method esGroso() {
    self.esInteligente() || rol.esGroso(self)
  }

  //abstracto
  method esInteligente()

}

class Humano inherits Personaje {
  override method esInteligente() = inteligencia > 50
}

class Orco inherits Personaje {
  override method esInteligente() = false
  override method potencialOfensivo() {
    return
    super() + rol.brutalidadInnata(super())
  }
}

object rolGuerrero  {
  method extra() = 100
  method brutalidadInnata(unValor) {
    return 0
  }
  method esGroso(unPersonaje){
    return unPersonaje.fuerza() > 50
  }
  

}

class RolCazador  {
  var mascota = new Mascota(fuerza=0,edad=0,tieneGarras=false)
  method cambiarMascota(unaMascota) {
    mascota = unaMascota
  }
  method naceNuevaMascota(fuerza, edad, tieneGarras) {
    mascota = new Mascota(fuerza=fuerza, edad=edad, tieneGarras=tieneGarras)
  }

  method extra() = mascota.potencial()
  method brutalidadInnata(unValor) {
    return 0
  }

  method esGroso(unPersonaje){
    return mascota.esLongeva()
  }
}

object rolBrujo  {
  method extra() = 0
  method brutalidadInnata(unValor) {
    return unValor * 0.1
  }
  method esGroso(unPersonaje){
    return true
  }

}

class Mascota {
  const fuerza 
  const edad 
  const tieneGarras 


  method initialize() { //debe llamarse asi
    if(fuerza > 100) {
      self.error("Una mascota no puede tener más de 100 de fuerza")
    }
  }

  method potencial() = if(tieneGarras) fuerza * 2 else fuerza 
  method esLongeva() = edad > 10
}

class Localidad {
  var ejercito = new Ejercito()
  method enlistar(unPersonaje) {
    ejercito.agregar(unPersonaje)
  }
  method poderDefensivo() = ejercito.potencial()
  method serOcupada(unEjercito)

}

class Aldea inherits Localidad {
  const cantMaxima
  override method enlistar(unPersonaje){
    if(ejercito.personajes().size() >= cantMaxima){
      self.error("Se alcanzó el limite maximo - ejercito completo")
    }
    super(unPersonaje)
  }
  override method serOcupada(unEjercito) {
    ejercito.clear()
    unEjercito.los10MasPoderosos().forEach({p=> self.enlistar(p)})
    unEjercito.quitarLosMasFuertes(cantMaxima.min(10))
  }
  


}

class Ciudad inherits Localidad {
  override method poderDefensivo() = super() + 300
  override method serOcupada(unEjercito) {
    ejercito  = unEjercito
  }

}
class Ejercito{
  const property personajes= #{}
  method potencial() =personajes.sum({p=> p.potencialOfensivo()})
  method agregar(unPersonaje){personajes.add(unPersonaje)}
  method invadir(unaLocalidad) {
    if(self.puedeInvadir(unaLocalidad)){
      unaLocalidad.serOcupada()
    }
  

  }

  method puedeInvadir(unaLocalidad) {
    return self.potencial() > unaLocalidad.poderDefensivo()
  }

  method los10MasPoderosos() = self.listaOrdenadaPorPoder().take(10)
  method listaOrdenadaPorPoder() {
    return personajes.asList().sortBy({p1,p2=>p1.potenciaonOfensivo() > p2.potencialOfensivo()})
  }
  method quitarLosMasFuertes(cantidadAQuitar) {
    personajes.removeAll(self.los10MasPoderosos().take(cantidadAQuitar))
  }
}