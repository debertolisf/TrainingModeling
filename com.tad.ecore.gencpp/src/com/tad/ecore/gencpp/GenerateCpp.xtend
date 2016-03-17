package com.tad.ecore.gencpp

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.ecore.EAttribute

class GenerateCpp {

	def getType(EAttribute a) { a.EType.instanceTypeName.replace("java.lang.", "") }

	def getAttType(EAttribute a) {
		switch a.EType.name {
			case "EString": "char*"
			case "EBoolean": "boolean"
			default: a.EType.name
		}
	}

	def generateClass(EClass c) '''
	public class «c.name»
	{
		«FOR a : c.EAllAttributes»
		private «getAttType(a)» «a.name»;
		«ENDFOR»
				
		public «c.name»()
		{
		}
		«FOR a : c.EAllAttributes»
		«generateSettersAndGetter(a)»
		«ENDFOR»
	};
	'''

	def generateSettersAndGetter(EAttribute a) {
		'''
		public void set«a.name.toFirstUpper()»(«getAttType(a)» value) {
			«a.name» = value;
		}
		public «getAttType(a)» get«a.name.toFirstUpper()»() {
			return «a.name»;
		}	 
		'''
	} 

	def static void main(String[] args) {
		val gen = new GenerateCpp
		println(gen.generateClass(EcorePackage.eINSTANCE.EClass))
	}
}
