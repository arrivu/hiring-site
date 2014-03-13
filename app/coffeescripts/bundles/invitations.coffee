require [
  'compiled/collections/PersonelCollection'
  'compiled/collections/AcademicsCollection'
  'compiled/collections/ExperienceCollection'
  'compiled/views/Invitations/IndexView'
#  'compiled/views/Invitations/PersonelCollectionView'
#  'compiled/views/Invitations/AcademicsCollectionView'
#  'compiled/views/Invitations/ExperienceCollectionView'
],(PersonelCollection, AcademicsCollection,ExperienceCollection, IndexView) ->

  # Collections

  personelCollection = new PersonelCollection
  academicsCollection = new AcademicsCollection
  experienceCollection = new ExperienceCollection

#  personelCollectionView = new PersonelCollectionView
#    personelcollection: personelCollection
#  academicsCollectionView = new AcademicsCollectionView
#    academicscollection: academicsCollection
#  experienceCollectionView = new ExperienceCollectionView
#    experiencecollection: experienceCollection

  @app = new IndexView
    el: '#new_form'
    personelCollectionView: personelCollection
#    academicsCollectionView: academicsCollectionView
#    experienceCollectionView: experienceCollectionView

  @app.render()

