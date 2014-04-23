require [
  'compiled/collections/PersonelCollection',
  'compiled/collections/AcademicsCollection',
  'compiled/collections/ExperienceCollection',
  'compiled/views/Invitations/IndexView'
  'compiled/views/Invitations/PersonelCollectionView'
], (PersonelCollection, AcademicsCollection,ExperienceCollection, IndexView, PersonelCollectionView) ->

  # Collections

  personelCollection = new PersonelCollection
  academicsCollection = new AcademicsCollection
  experienceCollection = new ExperienceCollection


  personelCollectionView = new PersonelCollectionView
    collection: personelCollection
  academicsCollectionView = new AcademicsCollectionView
      collection: academicsCollection
  experienceCollectionView = new ExperienceCollectionView
      collection: experienceCollection

  @app = new IndexView
    personelCollectionView: personelCollectionView
    academicsCollectionView: academicsCollectionView
    experienceCollectionView: experienceCollectionView
    el: '#new_form'

  @app.render()
