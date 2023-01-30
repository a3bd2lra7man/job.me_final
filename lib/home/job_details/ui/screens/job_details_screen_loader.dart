import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/home/job_details/ui/widgets/header_loader.dart';

class JobDetailsScreenLoader extends StatelessWidget {
  const JobDetailsScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: HeaderLoader(),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 40,
                    width: 120,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              child: SizedBox(
                height: 200,
                width: 200,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 40,
                    width: 120,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              child: SizedBox(
                height: 200,
                width: 200,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Card(
                child: SizedBox(
              width: 200,
              height: 64,
            )),
          )
        ],
      ),
    );
  }
}
