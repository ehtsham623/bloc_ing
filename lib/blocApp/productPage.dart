import 'package:bloc_ing/blocApp/productBloc.dart';
import 'package:bloc_ing/blocApp/productEvent.dart';
import 'package:bloc_ing/blocApp/productModel.dart';
import 'package:bloc_ing/blocApp/productState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products CRUD (BLoC)')),
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) return Center(child: Text('No products'));
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ListTile(
                    title: Text(p.title),
                    subtitle: Text('${p.description}\n\$${p.price.toStringAsFixed(2)}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _openProductForm(context, product: p),
                        ),
                        IconButton(icon: Icon(Icons.delete), onPressed: () => _confirmDelete(context, p)),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('Press + to add product'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProductForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete product'),
        content: Text('Delete "${p.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      context.read<ProductBloc>().add(DeleteProduct(p.id));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted')));
    }
  }

  void _openProductForm(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(product: product, pCtx: context),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  final BuildContext pCtx;
  const ProductFormDialog({super.key, this.product, required this.pCtx});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late TextEditingController _priceC;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.product?.title ?? '');
    _descC = TextEditingController(text: widget.product?.description ?? '');
    _priceC = TextEditingController(text: widget.product?.price.toString() ?? '0');
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit product' : 'Add product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleC,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _descC,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceC,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final parsed = double.tryParse(v);
                  if (parsed == null) return 'Invalid number';
                  if (parsed < 0) return 'Must be >= 0';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: Text(isEdit ? 'Save' : 'Create')),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleC.text.trim();
    final desc = _descC.text.trim();
    final price = double.parse(_priceC.text.trim());

    final bloc = BlocProvider.of<ProductBloc>(widget.pCtx);

    if (widget.product == null) {
      final newProduct = Product(id: '', title: title, description: desc, price: price);
      bloc.add(AddProduct(newProduct));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product created')));
    } else {
      final updated = widget.product!.copyWith(title: title, description: desc, price: price);
      bloc.add(UpdateProduct(updated));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated')));
    }
  }
}
