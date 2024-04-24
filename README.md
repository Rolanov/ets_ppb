# ets_ppb

Nama : Muhammad Rolanov Wowor
NRP : 5025201017
Kelas : PPB D

## Implementasi Aplikasi


Tampilan Books page:
![book_page.png](book_page.png)
<br>
Implementasi Create dan Edit Book: 
![create_book.png](create_book.png)
<br>
poin-poin penerapan:
- Columns
- Row
- Detail Buku, Kartu Buku (tampilan di home Page)
- Stateful widget: Halaman Buku, Detail Buku, Edit Buku
- Stateless Widget: Formulir pembuatan buku, Kartu Buku
<br>
Error handling:
```
  Future refreshBooks() async {
    setState(() => isLoading = true);

    try {
      books = await BooksDatabase.instance.readAllBooks();
    } catch (e) {
      // Handle the error, e.g., show a snackbar or display an error message
      print('Error loading books: $e');
      // Optionally, you can rethrow the error to propagate it further
      // throw e;
    }

    setState(() => isLoading = false);
    }
```